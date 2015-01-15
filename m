Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbbAOKOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:14:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52899 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbbAOKOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:14:14 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-66-54b792f3f881
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: david@fromorbit.com, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
 <1421165126-3585-12-git-send-email-linkinjeon@gmail.com>
 <20150114201610.GA49511@bfoster.bfoster>
In-reply-to: <20150114201610.GA49511@bfoster.bfoster>
Subject: RE: [PATCH v8 11/11] xfstests: fsx: Add fallocate insert range
 operation
Date: Thu, 15 Jan 2015 19:14:11 +0900
Message-id: <004201d030ac$01d949f0$058bddd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8HFfblg/gPWIGszLKUjAczsKp1gHWc7HLAgNEqqubyk0nkA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkRPfLpO0hBvvus1gsnXiJ2eLd5yqL
	LcfuMVpcv3uL2WLmvDtsFnv2nmSxuLxrDptFa89PdotFfbcYHTg9Ti2S8Ng56y67R9OZo8we
	qy9sZfR4v+8qm0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBlXOpOKlhtWrGycy5TA2O/Zhcj
	J4eEgInE4mcXWSBsMYkL99azdTFycQgJLGWUOHJ6BSNM0bLHjawQiUWMEvu+LWaEcP4ySvx/
	sgwow8HBJqAt8WeLKEiDiICvxP3lH8EamAVWM0qcn9IN1b2SUeLjvG4mkCpOAVOJi3NbWEFs
	YYFgiSO/74GtYxFQlfh/4yZYDa+ApcS3adfZIGxBiR+T74HdyiygJbF+53EmCFteYvOat8wQ
	pypI7Dj7mhHiCieJli6IXmYBEYl9L96BXS0h0Mohca3lBxPEMgGJb5MPsYB8ICEgK7HpANQc
	SYmDK26wTGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQKj
	/PS/ZxN2MN47YH2IUYCDUYmHl8Fve4gQa2JZcWXuIUZToIsmMkuJJucDU0leSbyhsZmRhamJ
	qbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYaybY3Tf31b7df/VkzPEI
	95p78v+ObzE/Uato/rJog11iac3rda8aLXMly2afUKngmGV04aPR6TX/TY7UdBWLtPqLV7G7
	s3KUSvdynRR+9+W5W+HjFTsa3jnu+Vj7SotT+z3jyhWa0ldUKzfeLzLx+FNsZ8DpdCBwSv8/
	83kP372L1mVYoSigxFKckWioxVxUnAgAXaKXn+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd3Pk7aHGOy+amGxdOIlZot3n6ss
	thy7x2hx/e4tZouZ8+6wWezZe5LF4vKuOWwWrT0/2S0W9d1idOD0OLVIwmPnrLvsHk1njjJ7
	rL6wldHj/b6rbB59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMeNSd1LBatOKlZ1zmRoY+zW7GDk5JARMJJY9bmSFsMUkLtxbz9bFyMUhJLCIUWLft8WM
	EM5fRon/T5YBVXFwsAloS/zZIgrSICLgK3F/+UdWkBpmgdWMEuendLNCNKxklPg4r5sJpIpT
	wFTi4twWsBXCAsESR37fYwSxWQRUJf7fuAlWwytgKfFt2nU2CFtQ4sfkeywgNrOAlsT6nceZ
	IGx5ic1r3jJDnKogsePsa0aIK5wkWrogepkFRCT2vXjHOIFRaBaSUbOQjJqFZNQsJC0LGFlW
	MYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnkGdSOxhXNlgcYhTgYFTi4WXw2x4ixJpYVlyZ
	e4hRgoNZSYS3MwcoxJuSWFmVWpQfX1Sak1p8iNEU6NOJzFKiyfnA9JZXEm9obGJmZGlkbmhh
	ZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cA4USO5W2HmJKamffIfPp1WCH6kweKcUhwq
	8veXqnruGjnT9ZKiUQZ5V2/ceitctPCH2wtz97AUHpGHNxgvze+a9XjJ2//sG3TuV/iK2Mp8
	ynO/c1wuMT56f/J09X9N9yZdlbGbt8tV+Ei/fn3qhI5LR3Y3MK+L/Dpj++kwn9TU3197jIVX
	F8xXYinOSDTUYi4qTgQAMnck+jcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >  		}
> >  		do_collapse_range(offset, size);
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		TRIM_OFF(offset, file_size);
> > +		TRIM_LEN(offset, size, maxfilelen - file_size);
> 
> Ugh, I hit a crash down in do_insert_range() due to the memset() on
> good_buf going off the end of the buffer. It looks like the TRIM_LEN()
> here is not correct and can result in a really large length value.
> 
> Perhaps something like TRIM_LEN(file_size, length, maxfilelen) is what
> we want for insert range ops?
Hi Brian,
Oops, Sorry about that.
And your change is correct.

Could you review the below updated patch ?

Thanks!

------------------------------------------------------------------------------
Subject: [PATCH v9 11/11] xfstests: fsx: Add fallocate insert range operation

This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 ltp/fsx.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 3709419..9fed5b2 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -95,7 +95,8 @@ int			logcount = 0;	/* total ops */
 #define OP_PUNCH_HOLE		6
 #define OP_ZERO_RANGE		7
 #define OP_COLLAPSE_RANGE	8
-#define OP_MAX_FULL		9
+#define OP_INSERT_RANGE	9
+#define OP_MAX_FULL		10
 
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
@@ -145,6 +146,7 @@ int     fallocate_calls = 1;            /* -F flag disables */
 int     punch_hole_calls = 1;           /* -H flag disables */
 int     zero_range_calls = 1;           /* -z flag disables */
 int	collapse_range_calls = 1;	/* -C flag disables */
+int	insert_range_calls = 1;		/* -i flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -339,6 +341,14 @@ logdump(void)
 						     lp->args[0] + lp->args[1])
 				prt("\t******CCCC");
 			break;
+		case OP_INSERT_RANGE:
+			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1]);
+			if (badoff >= lp->args[0] && badoff <
+						     lp->args[0] + lp->args[1])
+				prt("\t******CCCC");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -1012,6 +1022,59 @@ do_collapse_range(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FALLOC_FL_INSERT_RANGE
+void
+do_insert_range(unsigned offset, unsigned length)
+{
+	unsigned end_offset;
+	int mode = FALLOC_FL_INSERT_RANGE;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length insert range\n");
+		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
+		return;
+	}
+
+	if ((loff_t)offset >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping insert range behind EOF\n");
+		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
+		return;
+	}
+
+	log4(OP_INSERT_RANGE, offset, length, 0);
+
+	if (testcalls <= simulatedopcount)
+		return;
+
+	end_offset = offset + length;
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		      end_offset <= monitorend))) {
+		prt("%lu insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+			offset, offset+length, length);
+	}
+	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
+		prt("insert range: %x to %x\n", offset, length);
+		prterr("do_insert_range: fallocate");
+		report_failure(161);
+	}
+
+	memmove(good_buf + end_offset, good_buf + offset,
+		file_size - offset);
+	memset(good_buf + offset, '\0', length);
+	file_size += length;
+}
+
+#else
+void
+do_insert_range(unsigned offset, unsigned length)
+{
+	return;
+}
+#endif
+
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
@@ -1117,14 +1180,25 @@ docloseopen(void)
 	}
 }
 
-#define TRIM_OFF_LEN(off, len, size)	\
-do {					\
-	if (size)			\
-		(off) %= (size);	\
-	else				\
-		(off) = 0;		\
-	if ((off) + (len) > (size))	\
-		(len) = (size) - (off);	\
+
+#define TRIM_OFF(off, size)			\
+do {						\
+	if (size)				\
+		(off) %= (size);		\
+	else					\
+		(off) = 0;			\
+} while (0)
+
+#define TRIM_LEN(off, len, size)		\
+do {						\
+	if ((off) + (len) > (size))		\
+		(len) = (size) - (off);		\
+} while (0)
+
+#define TRIM_OFF_LEN(off, len, size)		\
+do {						\
+	TRIM_OFF(off, size);			\
+	TRIM_LEN(off, len, size);		\
 } while (0)
 
 void
@@ -1192,6 +1266,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_INSERT_RANGE:
+		if (!insert_range_calls) {
+			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			goto out;
+		}
+		break;
 	}
 
 	switch (op) {
@@ -1244,6 +1324,22 @@ test(void)
 		}
 		do_collapse_range(offset, size);
 		break;
+	case OP_INSERT_RANGE:
+		TRIM_OFF(offset, file_size);
+		TRIM_LEN(file_size, size, maxfilelen);
+		offset = offset & ~(block_size - 1);
+		size = size & ~(block_size - 1);
+		if (size == 0) {
+			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			goto out;
+		}
+		if (file_size + size > maxfilelen) {
+			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
+			goto out;
+		}
+
+		do_insert_range(offset, size);
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1307,6 +1403,9 @@ usage(void)
 #ifdef FALLOC_FL_COLLAPSE_RANGE
 "	-C: Do not use collapse range calls\n"
 #endif
+#ifdef FALLOC_FL_INSERT_RANGE
+"	-i: Do not use insert range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -1493,7 +1592,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCiLN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1599,6 +1698,9 @@ main(int argc, char **argv)
 		case 'C':
 			collapse_range_calls = 0;
 			break;
+		case 'i':
+			insert_range_calls = 0;
+			break;
 		case 'L':
 		        lite = 1;
 			break;
@@ -1758,6 +1860,8 @@ main(int argc, char **argv)
 		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
 	if (collapse_range_calls)
 		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
+	if (insert_range_calls)
+		insert_range_calls = test_fallocate(FALLOC_FL_INSERT_RANGE);
 
 	while (numops == -1 || numops--)
 		test();
-- 
1.7.7




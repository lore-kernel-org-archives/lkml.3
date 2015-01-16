Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbbAPH2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:28:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbAPH2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:28:00 -0500
X-AuditID: cbfee68d-f79296d000004278-63-54b8bd7d77af
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Namjae Jeon'" <linkinjeon@gmail.com>, david@fromorbit.com, tytso@mit.edu,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
 <1421165126-3585-12-git-send-email-linkinjeon@gmail.com>
 <20150114201610.GA49511@bfoster.bfoster>
 <004201d030ac$01d949f0$058bddd0$@samsung.com>
 <20150115122856.GB18876@bfoster.bfoster>
In-reply-to: <20150115122856.GB18876@bfoster.bfoster>
Subject: RE: [PATCH v8 11/11] xfstests: fsx: Add fallocate insert range
 operation
Date: Fri, 16 Jan 2015 16:27:57 +0900
Message-id: <005201d0315d$f3201530$d9603f90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8HFfblg/gPWIGszLKUjAczsKp1gHWc7HLAgNEqqsCTVoK+AFK5SNpm67zJcA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkULd2744Qg2uTLCyWTrzEbPHuc5XF
	lmP3GC2u373FbDFz3h02iz17T7JYXN41h82itecnu8WivluMDpwepxZJeOycdZfdo+nMUWaP
	1Re2Mnq833eVzaNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgylm/tZinYa19x/dYd9gbGZv0u
	Rk4OCQETic/3z7JB2GISF+6tB7K5OIQEljJK7N63lhWmaM71u+wQiemMEj/eH4By/jJKfD46
	k7GLkYODTUBb4s8WUZAGEQF1iTvzJrCA1DALXGSUmDrvNRNEQwuTxL89K1lAqjgFTCU2PHwJ
	tltYIFjiyO97jCA2i4CqxJRdX5lAbF4BS4kL31cyQtiCEj8m3wPrZRbQkli/8zgThC0vsXnN
	W2aIUxUkdpx9zQhxhZ/E6bOX2SBqRCT2vXjHCFHTySHxY38qxC4BiW+TD7GAPCAhICux6QDU
	GEmJgytusExglJiFZPMsJJtnIdk8C8mGBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzEC
	o/z0v2e9OxhvH7A+xCjAwajEw+uwaUeIEGtiWXFl7iFGU6CLJjJLiSbnA1NJXkm8obGZkYWp
	iamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJc8rQOXas048rU/9so3
	3oxgw+4nxddM+abxbrilnXx3942EB1Huj6/zzhRLWjit++GcfU83xxpLPVv/cWFvRJf7y5Zr
	slOt62I0tyznNl15yuyofri2vug+W//zol/WxOiZWr84XnjhulyCzZM9E5YHraxv+xmx6XyW
	wrTz5teYsntvN7DaZiuxFGckGmoxFxUnAgB3vpxw7QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd3avTtCDFbt0rdYOvESs8W7z1UW
	W47dY7S4fvcWs8XMeXfYLPbsPclicXnXHDaL1p6f7BaL+m4xOnB6nFok4bFz1l12j6YzR5k9
	Vl/Yyujxft9VNo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmLF8azdLwV77iuu37rA3MDbrdzFyckgImEjMuX6XHcIWk7hwbz1bFyMXh5DAdEaJH+8P
	sEM4fxklPh+dydjFyMHBJqAt8WeLKEiDiIC6xJ15E1hAapgFLjJKTJ33mgmioYVJ4t+elSwg
	VZwCphIbHr5kA7GFBYIljvy+xwhiswioSkzZ9ZUJxOYVsJS48H0lI4QtKPFj8j2wXmYBLYn1
	O48zQdjyEpvXvGWGOFVBYsfZ14wQV/hJnD57mQ2iRkRi34t3jBMYhWYhGTULyahZSEbNQtKy
	gJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwEnkmvYNxVYPFIUYBDkYlHt4ZW3aECLEm
	lhVX5h5ilOBgVhLh3bgNKMSbklhZlVqUH19UmpNafIjRFOjTicxSosn5wASXVxJvaGxiZmRp
	ZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA2CU8n7mfSd20ML2TJ0EtzZ5BcbrY
	5FJmrYrZXFcOb53ypbLwWO6y47NZfOeFWeuKvmo32RezIjAltCXILihadw/76bVBxRLe/+5s
	YP98dEuQY0CravvV5maOWufTvLeeb6+MMN5zchnjBsaY6ee4/tZfrDO7Y1VylCNK6dJBdb15
	WxVmms1UYinOSDTUYi4qTgQANpkDrTgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > > >  		}
> > > >  		do_collapse_range(offset, size);
> > > >  		break;
> > > > +	case OP_INSERT_RANGE:
> > > > +		TRIM_OFF(offset, file_size);
> > > > +		TRIM_LEN(offset, size, maxfilelen - file_size);
> > >
> > > Ugh, I hit a crash down in do_insert_range() due to the memset() on
> > > good_buf going off the end of the buffer. It looks like the TRIM_LEN()
> > > here is not correct and can result in a really large length value.
> > >
> > > Perhaps something like TRIM_LEN(file_size, length, maxfilelen) is what
> > > we want for insert range ops?
> > Hi Brian,
> > Oops, Sorry about that.
> > And your change is correct.
> >
> > Could you review the below updated patch ?
> >
> 
> This one looks good. Also, I ran overnight with the same change and it
> went for 23m ops. Not sure why it ended up stopping as the output files
> compare fine. I'll get it running on another box and see if I can
> repeat.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thanks you. If you find any issue, Please share with me.

> 
> > Thanks!
> >
> > ------------------------------------------------------------------------------
> > Subject: [PATCH v9 11/11] xfstests: fsx: Add fallocate insert range operation
> >
> > This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  ltp/fsx.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 files changed, 114 insertions(+), 10 deletions(-)
> >
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 3709419..9fed5b2 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -95,7 +95,8 @@ int			logcount = 0;	/* total ops */
> >  #define OP_PUNCH_HOLE		6
> >  #define OP_ZERO_RANGE		7
> >  #define OP_COLLAPSE_RANGE	8
> > -#define OP_MAX_FULL		9
> > +#define OP_INSERT_RANGE	9
> > +#define OP_MAX_FULL		10
> >
> >  /* operation modifiers */
> >  #define OP_CLOSEOPEN	100
> > @@ -145,6 +146,7 @@ int     fallocate_calls = 1;            /* -F flag disables */
> >  int     punch_hole_calls = 1;           /* -H flag disables */
> >  int     zero_range_calls = 1;           /* -z flag disables */
> >  int	collapse_range_calls = 1;	/* -C flag disables */
> > +int	insert_range_calls = 1;		/* -i flag disables */
> >  int 	mapped_reads = 1;		/* -R flag disables it */
> >  int	fsxgoodfd = 0;
> >  int	o_direct;			/* -Z */
> > @@ -339,6 +341,14 @@ logdump(void)
> >  						     lp->args[0] + lp->args[1])
> >  				prt("\t******CCCC");
> >  			break;
> > +		case OP_INSERT_RANGE:
> > +			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
> > +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> > +			    lp->args[1]);
> > +			if (badoff >= lp->args[0] && badoff <
> > +						     lp->args[0] + lp->args[1])
> > +				prt("\t******CCCC");
> > +			break;
> >  		case OP_SKIPPED:
> >  			prt("SKIPPED (no operation)");
> >  			break;
> > @@ -1012,6 +1022,59 @@ do_collapse_range(unsigned offset, unsigned length)
> >  }
> >  #endif
> >
> > +#ifdef FALLOC_FL_INSERT_RANGE
> > +void
> > +do_insert_range(unsigned offset, unsigned length)
> > +{
> > +	unsigned end_offset;
> > +	int mode = FALLOC_FL_INSERT_RANGE;
> > +
> > +	if (length == 0) {
> > +		if (!quiet && testcalls > simulatedopcount)
> > +			prt("skipping zero length insert range\n");
> > +		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
> > +		return;
> > +	}
> > +
> > +	if ((loff_t)offset >= file_size) {
> > +		if (!quiet && testcalls > simulatedopcount)
> > +			prt("skipping insert range behind EOF\n");
> > +		log4(OP_SKIPPED, OP_INSERT_RANGE, offset, length);
> > +		return;
> > +	}
> > +
> > +	log4(OP_INSERT_RANGE, offset, length, 0);
> > +
> > +	if (testcalls <= simulatedopcount)
> > +		return;
> > +
> > +	end_offset = offset + length;
> > +	if ((progressinterval && testcalls % progressinterval == 0) ||
> > +	    (debug && (monitorstart == -1 || monitorend == -1 ||
> > +		      end_offset <= monitorend))) {
> > +		prt("%lu insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> > +			offset, offset+length, length);
> > +	}
> > +	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> > +		prt("insert range: %x to %x\n", offset, length);
> > +		prterr("do_insert_range: fallocate");
> > +		report_failure(161);
> > +	}
> > +
> > +	memmove(good_buf + end_offset, good_buf + offset,
> > +		file_size - offset);
> > +	memset(good_buf + offset, '\0', length);
> > +	file_size += length;
> > +}
> > +
> > +#else
> > +void
> > +do_insert_range(unsigned offset, unsigned length)
> > +{
> > +	return;
> > +}
> > +#endif
> > +
> >  #ifdef HAVE_LINUX_FALLOC_H
> >  /* fallocate is basically a no-op unless extending, then a lot like a truncate */
> >  void
> > @@ -1117,14 +1180,25 @@ docloseopen(void)
> >  	}
> >  }
> >
> > -#define TRIM_OFF_LEN(off, len, size)	\
> > -do {					\
> > -	if (size)			\
> > -		(off) %= (size);	\
> > -	else				\
> > -		(off) = 0;		\
> > -	if ((off) + (len) > (size))	\
> > -		(len) = (size) - (off);	\
> > +
> > +#define TRIM_OFF(off, size)			\
> > +do {						\
> > +	if (size)				\
> > +		(off) %= (size);		\
> > +	else					\
> > +		(off) = 0;			\
> > +} while (0)
> > +
> > +#define TRIM_LEN(off, len, size)		\
> > +do {						\
> > +	if ((off) + (len) > (size))		\
> > +		(len) = (size) - (off);		\
> > +} while (0)
> > +
> > +#define TRIM_OFF_LEN(off, len, size)		\
> > +do {						\
> > +	TRIM_OFF(off, size);			\
> > +	TRIM_LEN(off, len, size);		\
> >  } while (0)
> >
> >  void
> > @@ -1192,6 +1266,12 @@ test(void)
> >  			goto out;
> >  		}
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		if (!insert_range_calls) {
> > +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> > +			goto out;
> > +		}
> > +		break;
> >  	}
> >
> >  	switch (op) {
> > @@ -1244,6 +1324,22 @@ test(void)
> >  		}
> >  		do_collapse_range(offset, size);
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		TRIM_OFF(offset, file_size);
> > +		TRIM_LEN(file_size, size, maxfilelen);
> > +		offset = offset & ~(block_size - 1);
> > +		size = size & ~(block_size - 1);
> > +		if (size == 0) {
> > +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> > +			goto out;
> > +		}
> > +		if (file_size + size > maxfilelen) {
> > +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> > +			goto out;
> > +		}
> > +
> > +		do_insert_range(offset, size);
> > +		break;
> >  	default:
> >  		prterr("test: unknown operation");
> >  		report_failure(42);
> > @@ -1307,6 +1403,9 @@ usage(void)
> >  #ifdef FALLOC_FL_COLLAPSE_RANGE
> >  "	-C: Do not use collapse range calls\n"
> >  #endif
> > +#ifdef FALLOC_FL_INSERT_RANGE
> > +"	-i: Do not use insert range calls\n"
> > +#endif
> >  "	-L: fsxLite - no file creations & no file size changes\n\
> >  	-N numops: total # operations to do (default infinity)\n\
> >  	-O: use oplen (see -o flag) for every op (default random)\n\
> > @@ -1493,7 +1592,7 @@ main(int argc, char **argv)
> >
> >  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
> >
> > -	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZ"))
> > +	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCiLN:OP:RS:WZ"))
> >  	       != EOF)
> >  		switch (ch) {
> >  		case 'b':
> > @@ -1599,6 +1698,9 @@ main(int argc, char **argv)
> >  		case 'C':
> >  			collapse_range_calls = 0;
> >  			break;
> > +		case 'i':
> > +			insert_range_calls = 0;
> > +			break;
> >  		case 'L':
> >  		        lite = 1;
> >  			break;
> > @@ -1758,6 +1860,8 @@ main(int argc, char **argv)
> >  		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
> >  	if (collapse_range_calls)
> >  		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
> > +	if (insert_range_calls)
> > +		insert_range_calls = test_fallocate(FALLOC_FL_INSERT_RANGE);
> >
> >  	while (numops == -1 || numops--)
> >  		test();
> > --
> > 1.7.7
> >
> >
> >


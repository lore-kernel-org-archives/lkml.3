Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3LETC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:02:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22129 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723Ab3LETCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:02:24 -0500
X-Greylist: delayed 2589 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:02:24 EST
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Chris Mason <clm@fb.com>
In-Reply-To: <CA+55aFz3sxb5h+m2eC8KniJjE4dA1F2Pzcu=9DfZRRzZakiBDw@mail.gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20131204175350.3449.17368@hit-nxdomain.opendns.com>
 <CA+55aFz3sxb5h+m2eC8KniJjE4dA1F2Pzcu=9DfZRRzZakiBDw@mail.gmail.com>
Message-ID: <20131205181908.26814.83252@ret>
User-Agent: alot/0.3.5
Subject: Re: [GIT PULL] Btrfs Maintainer update
Date: Thu, 5 Dec 2013 13:19:09 -0500
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-05_06:2013-12-05,2013-12-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1312050108
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (2013-12-05 12:53:26)
> On Wed, Dec 4, 2013 at 9:53 AM, Chris Mason <clm@fb.com> wrote:
> >
> > Instead of diffstat etc, I've put the patch below.  The commit is also
> > signed, my updated key should be floating around the pgp servers now.
> 
> You've done something to the git tree since your test request, because
> now the signed tag isn't there any more, now it's just a regular
> branch.
> 
> Mind re-uploading the *tag*, which is where the signature is?

I had used git commit -S instead of signing the tag.  I just pushed out
a signed tag on for-linus as well.

-chris


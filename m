Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3LKI2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:28:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18897 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LKI2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:28:18 -0500
Date: Wed, 11 Dec 2013 11:27:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Kees Cook <keescook@google.com>, Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        xfs@oss.sgi.com, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131211082740.GP5443@mwanda>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
 <20131209121534.GE4278@hercules>
 <CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
 <20131209235523.GW31386@dastard>
 <CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
 <20131211010326.GF10988@dastard>
 <CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
 <20131211020007.GH10988@dastard>
 <CAGXu5jKUShtztTK-PtY7w0WSg=F3KUGL-iCM3=6H61qy3u6aZg@mail.gmail.com>
 <20131211041758.GI10988@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211041758.GI10988@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't really expecting it to get a CVE since it requires
CAP_SYS_ADMIN but I should have added the CC to stable.  Sorry about
that.

regards,
dan carpenter


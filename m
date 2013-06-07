Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3FGA5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:57:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18715 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3FGA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:57:07 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-d7-51b12fe13e47
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Eric Piel'" <eric.piel@tremplin-utc.net>,
        "'Dimitri Sivanich'" <sivanich@sgi.com>, "'Robin Holt'" <holt@sgi.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <001201ce60d9$c815e190$5841a4b0$@samsung.com>
 <20130606195159.GA13011@kroah.com>
In-reply-to: <20130606195159.GA13011@kroah.com>
Subject: Re: [PATCH V3] rtc: rtc-pcf2123: replace strict_strtoul() with
 kstrtoul()
Date: Fri, 07 Jun 2013 09:57:05 +0900
Message-id: <002b01ce6319$ede58fa0$c9b0aee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH0TncLmc1UFtSeFCQiIujZNSx0bAGhDB58mNCN0HA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zA92H+hsDDVZft7J4OeEwo8XfScfY
	LQ7/vcRi0bx4PZtF/7QOVovLCy8BiV1z2CwmHN7MbjF5Sxu7A6fHq6uOHr9/TWL02DnrLrvH
	/rlr2D36tqxi9Lh7/SWTx4UWbo/Pm+QCOKK4bFJSczLLUov07RK4MrpWCxY0sVdcXnuftYHx
	AGsXIweHhICJxOtnZV2MnECmmMSFe+vZuhi5OIQEljFKHN++lx2m5sMXI4j4IkaJqXfeMkE4
	vxglZr5axwjSzSagJvHly2F2EFtEwFRi4/spjCBFzAJ7mCTebngPViQkECdx+cERsM2cAvoS
	u9ZKgYSFBUIkdsz7yQpiswioSkzePA2snFfAUuLp9WPMELagxI/J91hAbGYBLYn1O48zQdjy
	EpvXvGWG+EBBYsfZ14wQN1hJ3F32BKpGRGLfi3eMEDUTOSR+PTGB2CUg8W3yIRaIJ2UlNh2A
	GiMpcXDFDZYJjBKzkGyehWTzLCSbZyHZsICRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZG
	SJz37mC8fcD6EGMy0PqJzFKiyfnANJFXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkaNw6dOrb0t82V99t7n/RpOW3yXzZWy/3HF+vbWpmWP6mQ0
	Vld8in57uL/z+82I4MLFbJHa6Q0P1d2PX5pa8yJ+4U1Fky1vCt3Nn/sEcEdkc4ptU1n0/pxY
	iezk/hldW9vTwpzar31orlRRlRGpmX5gdR0L127mXfdXsBmFzJZLP7lM2iLvxCQlluKMREMt
	5qLiRABROhooCQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd2H+hsDDb7uMLV4OeEwo8XfScfY
	LQ7/vcRi0bx4PZtF/7QOVovLCy8BiV1z2CwmHN7MbjF5Sxu7A6fHq6uOHr9/TWL02DnrLrvH
	/rlr2D36tqxi9Lh7/SWTx4UWbo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTX
	Y2SABhLWMWZ0rRYsaGKvuLz2PmsD4wHWLkYODgkBE4kPX4y6GDmBTDGJC/fWs3UxcnEICSxi
	lJh65y0ThPOLUWLmq3WMIFVsAmoSX74cZgexRQRMJTa+n8IIUsQssIdJ4u2G92BFQgJxEpcf
	HAHbwCmgL7FrrRRIWFggRGLHvJ+sIDaLgKrE5M3TwMp5BSwlnl4/xgxhC0r8mHyPBcRmFtCS
	WL/zOBOELS+xec1bZohLFSR2nH3NCHGDlcTdZU+gakQk9r14xziBUWgWklGzkIyahWTULCQt
	CxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5JnUjsYVzZYHGIU4GBU4uH9uWpDoBBr
	YllxZe4hRgkOZiUR3lMaGwOFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+Y5PJK4g2NTcyM
	LI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgXEJw9RKycyza2T3rMxoXX5z
	y43VDQs4fPcGPjDRcd2tu6bj9q2nb7Ye1vP/5bGz9FmS01XGE6ZlvQ6hK798fve+1qu968km
	vbsf7kaYzI5Rq3oYZ/RRpuBZ2szqLf8LbA+a3foXNUnyo/g7VbPgbWvKm9/PvCaqPs914d/m
	t3tnRuWmaa7zLTNSYinOSDTUYi4qTgQAZ3vGVmgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 4:52 AM, Greg Kroah-Hartman wrote:
> On Tue, Jun 04, 2013 at 01:12:52PM +0900, Jingoo Han wrote:
> > The usage of strict_strtoul() is not preferred, because
> > strict_strtoul() is obsolete. Thus, kstrtoul() should be
> > used.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> > Changes since v1:
> > - Splitted to two sequential checks.
> > - Added Andy Shevchenko's Reviewed-by.
> >
> > Changes since v1:
> > - Used return code from kstrtoul().
> >
> >  drivers/rtc/rtc-pcf2123.c |   15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> I'm not the drivers/rtc/ maintainer, why send this to me?

Hi Greg,

Sorry. It's my mistake.
I will re-send it to the maintainer of rtc.
Thank you.

Best regards,
Jingoo Han

> 
> greg k-h


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDOGaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:30:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59414 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDOGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:30:12 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-d2-534cd1f28008
Date: Tue, 15 Apr 2014 06:30:10 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] PM / devfreq: Use freq_table for available_frequencies
To: Saravana Kannan <skannan@codeaurora.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140415055402791@myungjoo.ham
Msgkey: 20140415055402791@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140415055402791@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1368716.232331397543409452.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42JZI2JSrPvpok+wwfUOLYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXR/mIpe8EZ/orXV9pYGhin8HcxcnIICahLLFpykq2LkYNDQsBE
	YvFtGZCwhICYxIV764HCXEAlSxklznZ+Y4SpWbqUHSI+n1Hi1OrD7CANLAKqEqdPb2EHqWET
	MJe4PyMIJCws4C9xtB+iRERAT+JI0wpWkF5mgfNMEhe7TjFB3KAksWbfKxYQm1dAUOLkzCcs
	EEeoSjSfXAs2k1dATWLXFh2IsITErOkXWCFsXokZ7U+hyuUkpn1dwwxhS0ucn7WBEeaXxd8f
	Q8X5JY7d3sEE8QqvxJP7wTBjdm/+wgZhC0hMPXMQqlVLYs+9NVDj+STWLHzLAjNm16nlzDC9
	97fMBfuEWUBRYkr3Q3YIW0viy499bOi+4hVwlmi+c5dlAqPyLCSpWUjaZyFpR1azgJFlFaNo
	akFyQXFSepGhXnFibnFpXrpecn7uJkZgSjj971nvDsbbB6wPMSYDY2Qis5Rocj4wpeSVxBsa
	mxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyOLgKLNzLu/
	3v8uEF0/Z2un2uH9esGXLgnylu2+t/KccvoN3Rui+u8leaOYo3dFvY+sv/tR7XDoTN/9st5v
	6g6ctDD1s5FuLZG7e2fJrSke3tpb1xQUZKs/Fq+yfshlLnilJaVV6LD509tusiF7ufs5H3bZ
	3y8ScHh4n3WPUnLlspS3by+ZmSmxFGckGmoxFxUnAgDOQEwaHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tmbqfLvoEGxx6rmRxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jLa
	XyxlLzjDX/H6ShtLA+MU/i5GTg4hAXWJRUtOsnUxcnBICJhILF3KDhKWEBCTuHBvPVCYC6hk
	PqPEqdWHwRIsAqoSp09vYQepZxMwl7g/IwgkLCzgL3G0H6JEREBP4kjTClaQXmaB80wSF7tO
	MUHsUpJYs+8VC4jNKyAocXLmExaIZaoSzSfXgs3kFVCT2LVFByIsITFr+gVWCJtXYkb7U6hy
	OYlpX9cwQ9jSEudnbWCEuXnx98dQcX6JY7d3MEG8xSvx5H4wzJjdm7+wQdgCElPPHIRq1ZLY
	c28N1Hg+iTUL37LAjNl1ajkzTO/9LXPBPmEWUJSY0v2QHcLWkvjyYx8buq94BZwlmu/cZZnA
	KDcLSWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYaJXnJhbXJqXrpecn7uJEZyani3ZwdhwwfoQ
	owAHoxIP74R33sFCrIllxZW5hxglOJiVRHhfJ/sEC/GmJFZWpRblxxeV5qQWH2JMBsbfRGYp
	0eR8YNrMK4k3NDY2MTMxtTSxMDA1J01YSZx3wa2kICGB9MSS1OzU1ILUIpgtTBycUg2MB0Mf
	2YrsSJkbsH/1JjlD1pow8V0lH+9YLb6XGNLw++u/hMQdP7x3vT31qjdJcNaOSAa3yIO60os2
	bmL9fdBHSj/oxbQp723vf7gYMfGJGKPYYcOHO//ZO6u6XG/gvNhkuWt56Qnt7d7+niEznrCt
	L2hv/KjfyPyhOKJPX6ivik3h1pkpx/3KlFiKMxINtZiLihMBDiwUTJEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3F6UR5c024227

> On 04/14/2014 06:36 PM, «‘∏Ì¡÷ wrote:
> >> MyungJoo/Kyungmin,
> >>
> >> Bump. Can we accept this patch please?
> >>
> >> -Saravana
> > 
> > Nack.
> > 
> > Please note that freq_table is also an optional value, which may
> > be null.
> 
> Ah, I saw that the max_freq would be zero if freq_table was NULL and I
> assumed that it can't be NULL. But I see that the max_freq limit is not
> applied if it's zero. Thanks for catching it.
> 
> > Besides, please be aware that your code is under rcu_read_lock().
> 
> Valid point. I was just trying to keep the diff simple. No one's really
> going to be catting this file often when performance matters.
> 
> > 
> > 
> > Cheers,
> > MyungJoo.
> > 
> > ps. I'll send a related patch (avoid accessing null but not-an-error
> > pointer at other sysfs nodes). Thank you for letting me catch such bugs anyway.
> 
> I can go ahead and do this myself if you don't mind.

No, we don't need it. It was a false alarm.
Reading again, I've found that we've already made other sysfs nodes
check if either freq_table is null or its size is 0.

So, we only need to look at this available_frequencies node now.

I'll add some notes on the ABI doc for available_frequencies soon.

Cheers,
MyungJoo.

> 
> -Saravana
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

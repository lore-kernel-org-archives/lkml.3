Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3LSWPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:15:54 -0500
Received: from smtprelay0169.hostedemail.com ([216.40.44.169]:44636 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755906Ab3LSWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:15:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:967:968:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2538:2553:2561:2564:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3770:3855:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4605:4823:5007:6117:6119:6755:7652:7773:7809:7903:8599:8957:8985:9025:9388:9389:9855:10004:10400:10848:10920:11232:11658:11914:12043:12219:12296:12517:12519:12555:12663:12682:12740:12776:13019:13437:19902:19997:21060,0,RBL:none,C
X-HE-Tag: stamp74_32cd3401ed24c
X-Filterd-Recvd-Size: 3212
Message-ID: <1387491348.2353.20.camel@joe-AO722>
Subject: Re: checkpatch.pl error might be false positive
From: Joe Perches <joe@perches.com>
To: Ravi Patel <rapatel@apm.com>, Josh Triplett <josh@joshtriplett.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kumar Sankaran <ksankaran@apm.com>,
        Loc Ho <lho@apm.com>, Keyur Chudgar <kchudgar@apm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Dec 2013 14:15:48 -0800
In-Reply-To: <CAN1v_PvS3dH6HVQ90d=3cfsSdMgieyoDNp3VN-vrHv-aqSFEAw@mail.gmail.com>
References: <CAN1v_PvS3dH6HVQ90d=3cfsSdMgieyoDNp3VN-vrHv-aqSFEAw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending adding lkml)
(adding Josh Triplett and Jesse Brandeburg)

On Thu, 2013-12-19 at 13:01 -0800, Ravi Patel wrote:
> Hi Andy, Joe
> 
> My name is Ravi Patel and I am working for AppliedMicro.
> I am planning to submit APM X-Gene SoC QMTM drivers to open source after
> running checkpatch.pl
> I am seeing following error saying remove FSF address from my patch, which
> I don't have in my source/header files.
> 
> ERROR: Do not include the paragraph about writing to the Free Software
> Foundation's mailing address from the sample GPL notice. The FSF has
> changed addresses in the past, and may do so again. Linux already includes
> a copy of the GPL.
> #1580: FILE: include/misc/xgene/xgene_qmtm.h:19:
> + * You should have received a copy of the GNU General Public License$
> 
> Here is my License banner in xgene_qmtm.h
> There are no tabs in my banner
> 
> /*
>  * AppliedMicro X-Gene SOC Queue Manager/Traffic Manager driver
>  *
>  * Copyright (c) 2013 Applied Micro Circuits Corporation.
>  * Author: Ravi Patel <rapatel@apm.com>
>  *         Keyur Chudgar <kchudgar@apm.com>
>  *         Fushen Chen <fchen@apm.com>
>  *
>  * This program is free software; you can redistribute  it and/or modify it
>  * under  the terms of  the GNU General  Public License as published by the
>  * Free Software Foundation;  either version 2 of the  License, or (at your
>  * option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>  *
>  */
> 
> Can you please check if the error is false positive.

Josh?

Is the intent that the "copy of the GNU General Public License"
statement should also be removed?

Jesse had a question recently about the appropriateness of the
removal given the license text.

http://www.spinics.net/lists/netdev/msg262152.html




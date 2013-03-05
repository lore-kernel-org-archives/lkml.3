Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3CEPWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:22:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab3CEPWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:22:19 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130305081519.GA19165@sgi.com>
References: <20130228205206.GC3438@sgi.com> <512FC697.3090608@zytor.com> <20130228210910.GD3438@sgi.com> <512FC82B.40909@zytor.com> <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com> <512FE3AE.4070903@zytor.com> <20130305081519.GA19165@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 05 Mar 2013 07:22:11 -0800
To: Robin Holt <holt@sgi.com>
CC: Yinghai Lu <yinghai@kernel.org>, hpa@sgi.com, linux-kernel@vger.kernel.org
Message-ID: <9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please do the analysis I asked for.

Robin Holt <holt@sgi.com> wrote:

>On Thu, Feb 28, 2013 at 03:09:34PM -0800, H. Peter Anvin wrote:
>> On 02/28/2013 03:02 PM, Yinghai Lu wrote:
>> > 
>> > Good, kexec is not only one.
>> > 
>> > ELILO has one.
>> >         5  ELILO
>> > 
>> > We need switch/case to have different fields set for it.
>> > 
>> 
>> I wouldn't consider that "good", but it's a bloody good thing we have
>> bootloader IDs.
>
>What is the planned course of action here.  With this commit applied,
>I still cannot boot.  Is there something you are waiting for from me?
>
>Thanks,
>Robin

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

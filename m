Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbaJUQkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:40:14 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42207 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaJUQkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <5446858B.3040107@gmx.de>
References: <5445479C.4030201@gmx.de>
	<5446858B.3040107@gmx.de>
Date: Tue, 21 Oct 2014 12:40:10 -0400
X-Google-Sender-Auth: EW5CrhgvJNg4nyvDR1yJ4ElwizM
Message-ID: <CA+5PVA5MCRhwnkbNXpMmLzeM4G=aau0kuRU_wma-5T59M+2vkA@mail.gmail.com>
Subject: Re: v3.18-rc1 32 bit KVM hangs early in boot process
From: Josh Boyer <jwboyer@fedoraproject.org>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: virtualization@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:10 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 10/20/2014 07:34 PM, Toralf Förster wrote:
>> I uploaded the screen shots from the virt-manager to [1] and [2]
>>
>> FWIW e56d9fccb was fine so the bug slipped in after that.
>>
>
>>
>> [1] http://www.directupload.net/file/d/3781/j9mwrtpq_jpg.htm
>> [2] http://www.directupload.net/file/d/3781/29trc56v_jpg.htm
>>
> It might be virtio-console related, when the uevetns are processed:
>
> http://www.directupload.net/file/d/3782/6lg5yihh_jpg.htm

Try
http://mid.gmane.org/1413813529-11044-1-git-send-email-cornelia.huck@de.ibm.com

josh

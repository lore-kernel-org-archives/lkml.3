Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3GaCJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:09:38 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46231 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3GaCJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <51F86F9A.4090104@gmail.com>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<51F7546C.9030901@gmail.com>
	<51F755E3.8040706@gmail.com>
	<3453253.oZLO1ChPbL@vostro.rjw.lan>
	<CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
	<51F86F9A.4090104@gmail.com>
Date: Tue, 30 Jul 2013 21:09:33 -0500
Message-ID: <CAMP44s2HUpVp-hoAH1LcHLURLP00R=B8czjrfCFbwGBMEyU5XA@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 8:59 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> On 07/31/2013 04:59 AM, Felipe Contreras wrote:

>> There is another interface the turn the screen off.
>>
>> If 0 turns the screen off with the intel driver, 0 should turn the
>> screen off with the ACPI driver, having inconsistent behavior
>> depending on which driver is used is a bug.
>
> I'm not sure of this. Remember the days when we switch the hard disk
> driver from IDE to SCSI? The block device name changed from hdx to sdx.
> Is this a bug?

The name might have changed, but the way the interface worked did not;
both hdx and sdx worked exactly the same.

-- 
Felipe Contreras

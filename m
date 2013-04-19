Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826Ab3DSPOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:14:52 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44861 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656Ab3DSPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:14:49 -0400
Message-ID: <51715F5C.3050502@gmail.com>
Date: Fri, 19 Apr 2013 23:14:36 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Boszormenyi Zoltan <zboszor@pr.hu>
CC: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: Re: ahci driver cannot suspend a CF card, ata_piix can
References: <516D3CEF.6010202@pr.hu>
In-Reply-To: <516D3CEF.6010202@pr.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 07:58 PM, Boszormenyi Zoltan wrote:
> Hi,
>
> The SATA interface can be switched between AHCI and legacy modes as usual:
>
> 00:1f.2 SATA controller: Intel Corporation NM10/ICH7 Family SATA
> Controller [AHCI mode] (rev 02)
>
> The device attached to the SATA controller is always a CF card via a
> SiI3811 Serial ATA to Parallel ATA Device Bridge based converter board.

Can you please attach a normal sata disk and try again with the
controller set to AHCI mode? I suspect it may be the SiI3811 bridge that
caused this command.

Thanks,
Aaron


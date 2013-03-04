Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3CDWPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:15:09 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:62792 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3CDWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:15:07 -0500
Message-ID: <51351CE8.5020500@pobox.com>
Date: Mon, 04 Mar 2013 17:15:04 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: rjw@sisk.pl, aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] libata-acpi.c: fix copy and paste mistake in ata_acpi_register_power_resource
References: <2508494.4AbRYXD1du@vostro.rjw.lan> <1362136602-30327-1-git-send-email-linux@eikelenboom.it>
In-Reply-To: <1362136602-30327-1-git-send-email-linux@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 06:16 AM, Sander Eikelenboom wrote:
> Fix a copy and paste mistake introduced in:
>
> commit bc9b6407bd6df3ab7189e5622816bbc11ae9d2d8
> "ACPI / PM: Rework the handling of devices depending on power resources"
>
> Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
> ---
>   drivers/ata/libata-acpi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

applied




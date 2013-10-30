Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3J3TNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:13:04 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41916 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3J3TNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <20131030143923.GA9996@console-pimps.org>
References: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
	<20131030123850.GA8193@console-pimps.org>
	<CAGG-pUQZ2R0JMZuGi07cL5q4EABYouZJfMpkO6YPy+ry2WkbNw@mail.gmail.com>
	<20131030143923.GA9996@console-pimps.org>
Date: Wed, 30 Oct 2013 17:13:00 -0200
Message-ID: <CAGG-pUTYhJZvjosykckFjRiKE-isKbCPTtomY3jTxrU2_a1LJA@mail.gmail.com>
Subject: Re: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matthew.garrett@nebula.com, Jeremy Kerr <jk@ozlabs.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30 Matt Fleming <matt@console-pimps.org>:
> On Wed, 30 Oct, at 10:44:16AM, Geyslan Gregório Bem wrote:
>> Do you want that I undo that? I aggre that the variable use only
>> reduces the line code.
>
> Yes please.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Done:
[PATCH v2] efivarfs: 'efivarfs_file_write' function reorganization

-- 
Regards,

Geyslan G. Bem
hackingbits.com

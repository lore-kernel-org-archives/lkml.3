Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3CGPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:09:21 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49316 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025Ab3CGPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:09:20 -0500
Message-ID: <1362668955.15011.204.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivarfs: loosen restriction on valid names
From: Matt Fleming <matt.fleming@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Date: Thu, 07 Mar 2013 15:09:15 +0000
In-Reply-To: <5138ACFE.30701@canonical.com>
References: <5138ACFE.30701@canonical.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 16:06 +0100, Maarten Lankhorst wrote:
> Commit da27a2438 (efivarfs: guid part of filenames are case-insensitive) fails to boot,
> because the kernel creates files in the form of dump-type-x-y-z-GUID. Since the kernel already
> created files in this form, these type of files obviously exist, so the right course of action
> is to relax the restriction in efivarfs_valid_name.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: stable@vger.kernel.org [3.8]

http://marc.info/?l=linux-kernel&m=136266857528382&w=2



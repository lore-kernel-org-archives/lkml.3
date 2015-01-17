Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbbAQVKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 16:10:14 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:49480 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbAQVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 16:10:12 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <54BAC21D.9040009@redhat.com>
References: <54BAC21D.9040009@redhat.com>
Date: Sat, 17 Jan 2015 13:10:11 -0800
Message-ID: <CAOesGMi3=QkiQ326nFfGTjsOKrGqgO-q+r+A4Uc_9YWCDrAtwA@mail.gmail.com>
Subject: Re: SMBIOS/DMI data under CONFIG_STRICT_DEVMEM
From: Olof Johansson <olof@lixom.net>
To: Jon Masters <jcm@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 17, 2015 at 12:12 PM, Jon Masters <jcm@redhat.com> wrote:
> Hi Catalin, all,
>
> I would like to ensure that the SMBIOS data provided by firmware is
> always readable from userspace on AArch64, through /dev/mem.

Seems like this would be a good opportunity for cleanup and fixing
userspace to use /sys/firmware/dmi interfaces instead of having to go
poking through /dev/mem. That way they don't have to be privileged
process any more and is a general security benefit for everybody.


-Olof

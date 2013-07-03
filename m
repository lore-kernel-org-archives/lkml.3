Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab3GCMiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:38:00 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33192 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab3GCMh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:37:57 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH 1/2] Fix a build warning in scripts/sortextable.h
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <51D418DB.5060102@suse.cz>
Date: Wed, 3 Jul 2013 22:37:47 +1000
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E04C38F7-0FF7-4B8A-8A3B-9EC135BFEB4F@gmail.com>
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com> <51D413D9.8040604@suse.cz> <51D41413.9060500@suse.cz> <015BB7AD-78C4-4F1A-B65A-B37FBB6E2B9C@gmail.com> <51D418DB.5060102@suse.cz>
To: Michal Marek <mmarek@suse.cz>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/07/2013, at 10:28 PM, Michal Marek <mmarek@suse.cz> wrote:
> 
> 
> What is the type of Elf64_Shdr::sh_offset in OS X's <elf.h>? In glibc,
> this is Elf64_Off, which is a typedef name for uint64_t.

Huh, that's weird. Elf64_Off is defined as unsigned long in my elf.h which isn't 64 bit on x86_64 pretty sure.

It's a problem on my side then, apologies.

> 
> Michal

Cheers,
tangrs
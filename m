Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaADTEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 14:04:30 -0500
Received: from www.sr71.net ([198.145.64.142]:35335 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaADTE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 14:04:28 -0500
Message-ID: <52C85B34.6040001@sr71.net>
Date: Sat, 04 Jan 2014 11:04:20 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] kconfig: consolidate arch-specific seccomp options
References: <20140102202014.CA206E9B@viggo.jf.intel.com> <20140105023853.dda6c1f9c6f9875159634e69@canb.auug.org.au>
In-Reply-To: <20140105023853.dda6c1f9c6f9875159634e69@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2014 07:38 AM, Stephen Rothwell wrote:
> On Thu, 02 Jan 2014 12:20:14 -0800 Dave Hansen <dave@sr71.net> wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>> There is *NOTHING* architecture-specific about SECCOMP except
>> that the syscalls have per-architecture definitions, like every
>> other syscall.  It is absurd to have the option in the
>> arch-specific menus.
> 
> You seem to have (mostly) lost the dependency some of the architecture
> versions of config SECCOMP had on PROC_FS ...

I _believe_ the /proc interface has gone away.  I can't find any
reference to /proc/<pid>/seccomp in any of the code.  Is there some
/proc dependency that I'm missing outside of the removed
/proc/<pid>/seccomp interface?

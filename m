Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaBYVry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:47:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33181 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaBYVrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:47:52 -0500
Date: Tue, 25 Feb 2014 22:47:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, mjg59@srcf.ucam.org, jkosina@suse.cz,
        greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com
Subject: Re: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140225214748.GA21559@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
 <20140221145910.GE11531@pd.tnic>
 <20140224164131.GJ4631@redhat.com>
 <20140225203519.77abfa8d@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140225203519.77abfa8d@hananiah.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 08:35:19PM +0100, Petr Tesarik wrote:
> #define BIT(nr)                 (1UL << (nr))
> 
> For my part I'm not convinced it's a better way to do it, unless
> Borislav also wanted to suggest adding an enum for the bit number
> values...

Well,

#define KEXEC_FILE_UNLOAD	BIT(1)

is much more readable.

The enum thing is also nice to have but it's not my personal preference.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

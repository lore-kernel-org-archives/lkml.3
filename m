Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaHEQE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:04:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaHEQE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:04:58 -0400
Message-ID: <53E100A8.8070701@suse.cz>
Date: Tue, 05 Aug 2014 18:04:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Klemen Jan Enova <klemen.jan.enova@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: sortextable: change type and initialise variable
References: <53C4F06F.2090204@gmail.com>
In-Reply-To: <53C4F06F.2090204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 11:12, Klemen Jan Enova wrote:
> Change the type of 'relocs_size' from 'int' to 'Elf32_Word' and 
> initialize it to 0, to fix the "maybe uninitialised variable" compiler 
> warning.

Please include the verbatim warning in the commit message.



> Signed-off-by: Klemen Jan Enova <klemen.jan.enova@gmail.com>
> ---
> diff --git a/scripts/sortextable.h b/scripts/sortextable.h
> index 8fac3fd..537858d 100644
> --- a/scripts/sortextable.h
> +++ b/scripts/sortextable.h
> @@ -103,7 +103,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, 
> table_sort_

Your mailer corrupted the patch by inserting a line break here.


>          Elf_Sym *sort_needed_sym;
>          Elf_Shdr *sort_needed_sec;
>          Elf_Rel *relocs = NULL;
> -       int relocs_size;
> +       Elf32_Word relocs_size = 0;

... and changed tabs to spaces. Please send the patch to yourself first
and see if it applies with 'git am.'

Michal

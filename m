Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaBRO3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:29:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42068 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbaBRO3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:37 -0500
Message-ID: <53036E26.1040701@zytor.com>
Date: Tue, 18 Feb 2014 06:28:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
CC: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/6] kbuild: Remove relocations from kallsyms table
References: <1392733470-8228-1-git-send-email-andi@firstfloor.org> <1392733470-8228-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1392733470-8228-2-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 06:24 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Remove the ELF relocations from the kallsyms_address[] table.
> Instead we just store offsets to _text and relocate that while
> accessing the kallsyms table. This is done with a new
> kallsyms_offsets[] table. With these changes .tmp_kallsyms*.o
> becomes relocation free.
> 
> In theory this would also allow to shrink the kallsyms table
> on 64bit by using offsets.
> 

Why not do that, then?

	-hpa



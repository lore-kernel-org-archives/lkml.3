Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbbAEJoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:44:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbAEJoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:44:17 -0500
Message-ID: <54AA5CEF.50408@suse.cz>
Date: Mon, 05 Jan 2015 10:44:15 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] kbuild: Refactor ./Kbuild
References: <1420441036-5289-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1420441036-5289-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-05 07:57, Masahiro Yamada wrote:
> Changes in v2:
>   - Pass the include guard as an argument of cmd_offsets
>     as Michal Marek suggested.
> 
> Masahiro Yamada (2):
>   kbuild: merge bounds.h and asm-offsets.h rules
>   kbuild: remove redundant line from bounds.h/asm-offsets.h

Merged into kbuild.git#kbuild, thanks a lot!

Michal


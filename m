Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbbAHP1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:27:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbbAHP1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:27:12 -0500
Message-ID: <54AEA1CE.6000400@suse.cz>
Date: Thu, 08 Jan 2015 16:27:10 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: drop $(version_h) from MRPROPER_FILES
References: <1420705778-22468-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1420705778-22468-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-08 09:29, Masahiro Yamada wrote:
> Now $(version_h) is include/generated/uapi/linux/version.h.
> 
> $(version_h) in MRPROPER_FILES is redundant because it is covered
> by include/generated in MRPROPER_DIRS.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Applied to kbuild.git#kbuild, thanks.

Michal


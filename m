Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3KHJ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:58:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab3KHJ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:58:08 -0500
Message-ID: <527CB5AA.7060400@suse.cz>
Date: Fri, 08 Nov 2013 10:58:02 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: tkhai@yandex.ru, js1304@gmail.com, akpm@linux-foundation.org,
        schwab@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/tags.sh: remove obsolete __devinit[const|data]
References: <1382939358-4971-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1382939358-4971-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2013 06:49, Michael Opdenacker wrote:
> This removes the use of __devinitconst and __devinitdata in scripts/tags.sh,
> which were removed in 3.8.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied to kbuild.git#misc.

Michal


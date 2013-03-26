Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3CZVMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:12:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3CZVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:12:14 -0400
Date: Tue, 26 Mar 2013 22:12:13 +0100
From: Michal Marek <mmarek@suse.cz>
To: Vincent <vincent.stehle@laposte.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gitignore: ignore hz.bc
Message-ID: <20130326211213.GA22359@pobox.suse.cz>
References: <1364059103-29842-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364059103-29842-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 06:18:23PM +0100, Vincent wrote:
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> ---
>  kernel/.gitignore |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/.gitignore b/kernel/.gitignore
> index ab4f109..b3097bd 100644
> --- a/kernel/.gitignore
> +++ b/kernel/.gitignore
> @@ -4,3 +4,4 @@
>  config_data.h
>  config_data.gz
>  timeconst.h
> +hz.bc

This is already fixed in linux-next.

Michal

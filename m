Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaBASzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 13:55:01 -0500
Received: from linuxhacker.ru ([217.76.32.60]:52100 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbaBASzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 13:55:00 -0500
Subject: Re: lustre: remove unnecessary 'magic' from lustre_pack_request
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140130174851.GC1834@redhat.com>
Date: Sat, 1 Feb 2014 13:54:46 -0500
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5E60CDC9-F45C-4B04-B0C3-67C8780C5FD2@linuxhacker.ru>
References: <20140130174851.GC1834@redhat.com>
To: Dave Jones <davej@redhat.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jan 30, 2014, at 12:48 PM, Dave Jones wrote:

> This probably made more sense when the code supported multiple protocol versions,
> but now it's just obfuscation.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
> index 464479c0f00b..c319f74b04f6 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
> @@ -244,15 +244,7 @@ int lustre_pack_request(struct ptlrpc_request *req, __u32 magic, int count,
> 	LASSERT(lens[MSG_PTLRPC_BODY_OFF] == sizeof(struct ptlrpc_body));
> 
> 	/* only use new format, we don't need to be compatible with 1.4 */

Can you get rid of this line too please?

> -	magic = LUSTRE_MSG_MAGIC_V2;

Bye,
    Oleg


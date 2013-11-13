Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3KMX2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:28:33 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:14875 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3KMX23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:28:29 -0500
Message-ID: <52840B1B.5060205@tilera.com>
Date: Wed, 13 Nov 2013 18:28:27 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] tile: use generic fixmap.h
References: <1384262545-20875-1-git-send-email-msalter@redhat.com> <1384262545-20875-11-git-send-email-msalter@redhat.com>
In-Reply-To: <1384262545-20875-11-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 8:22 AM, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/fixmap.h | 33 +--------------------------------
>  1 file changed, 1 insertion(+), 32 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


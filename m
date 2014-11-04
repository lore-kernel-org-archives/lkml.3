Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaKDQZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:25:23 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59499 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaKDQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:25:18 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 4/4] of: Remove spaces before tabs
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
In-Reply-To: <1413971095-27192-4-git-send-email-geert+renesas@glider.be>
References: <1413971095-27192-1-git-send-email-geert+renesas@glider.be>
	<1413971095-27192-4-git-send-email-geert+renesas@glider.be>
Date: Tue, 04 Nov 2014 16:25:09 +0000
Message-Id: <20141104162509.15B6CC423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 11:44:55 +0200
, Geert Uytterhoeven <geert+renesas@glider.be>
 wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied all 4 patches. Thanks.

g.

> ---
>  drivers/of/base.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index cff3afcff1951faf..19075e770d8b6306 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -577,9 +577,9 @@ EXPORT_SYMBOL(of_get_parent);
>   *	of_get_next_parent - Iterate to a node's parent
>   *	@node:	Node to get parent of
>   *
> - * 	This is like of_get_parent() except that it drops the
> - * 	refcount on the passed node, making it suitable for iterating
> - * 	through a node's parents.
> + *	This is like of_get_parent() except that it drops the
> + *	refcount on the passed node, making it suitable for iterating
> + *	through a node's parents.
>   *
>   *	Returns a node pointer with refcount incremented, use
>   *	of_node_put() on it when done.
> @@ -1566,15 +1566,15 @@ EXPORT_SYMBOL(of_parse_phandle);
>   * Example:
>   *
>   * phandle1: node1 {
> - * 	#list-cells = <2>;
> + *	#list-cells = <2>;
>   * }
>   *
>   * phandle2: node2 {
> - * 	#list-cells = <1>;
> + *	#list-cells = <1>;
>   * }
>   *
>   * node3 {
> - * 	list = <&phandle1 1 2 &phandle2 3>;
> + *	list = <&phandle1 1 2 &phandle2 3>;
>   * }
>   *
>   * To get a device_node of the `node2' node you may call this:
> @@ -1615,7 +1615,7 @@ EXPORT_SYMBOL(of_parse_phandle_with_args);
>   * }
>   *
>   * node3 {
> - * 	list = <&phandle1 0 2 &phandle2 2 3>;
> + *	list = <&phandle1 0 2 &phandle2 2 3>;
>   * }
>   *
>   * To get a device_node of the `node2' node you may call this:
> -- 
> 1.9.1
> 


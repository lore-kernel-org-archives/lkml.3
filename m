Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaEZV1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:27:04 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:52541 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaEZV1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:27:00 -0400
Date: Mon, 26 May 2014 23:26:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2] sbus: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140526212633.GA30752@ravnborg.org>
References: <20140525105825.GA3437@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140525105825.GA3437@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi.

On Sun, May 25, 2014 at 04:28:25PM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. The header file is added to make the devm function explicitly
> available.
This version looks much better.
If you in the subject replaces sbus: with display7seg: then you can add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

"sbus:" is very generic, but this patch touches only
this single driver.

	Sam

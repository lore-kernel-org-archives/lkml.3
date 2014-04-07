Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaDGT1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:27:43 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:38147 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540AbaDGT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:27:39 -0400
Date: Mon, 7 Apr 2014 14:27:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mitchel Humpherys <mitchelh@codeaurora.org>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Some printk cleanup in mm
In-Reply-To: <1396894732-17963-1-git-send-email-mitchelh@codeaurora.org>
Message-ID: <alpine.DEB.2.10.1404071427120.4447@nuc>
References: <1396894732-17963-1-git-send-email-mitchelh@codeaurora.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014, Mitchel Humpherys wrote:

>   - v3: Leaving slub.c alone. It's using hand-tagged printk's
>     correctly so it's probably just churn to convert everything to the
>     pr_ macros.

Ok.

Ignored-by: Christoph Lameter <cl@linux.com>

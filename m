Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaIVRtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:49:53 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:40208 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbaIVRtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:49:52 -0400
From: Ashley Lai <ashley@ashleylai.com>
X-Google-Original-From: Ashley Lai <alai@ant>
Date: Mon, 22 Sep 2014 12:49:50 -0500 (CDT)
To: Anton Blanchard <anton@samba.org>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tpm/tpm_ibmvtpm: Remove unnecessary casts
In-Reply-To: <20140920073014.071007cc@kryten>
Message-ID: <alpine.DEB.2.10.1409221247370.4510@ant>
References: <20140920072942.27c28768@kryten> <20140920073014.071007cc@kryten>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Sep 2014, Anton Blanchard wrote:

> There is no need to cast from a void pointer to another pointer.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Ashley Lai <ashley@ashleylai.com>




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbaDKOiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:38:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbaDKOiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:38:06 -0400
Date: Fri, 11 Apr 2014 16:38:03 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Richard Leitner <me@g0hl1n.net>
Cc: r.marek@assembler.cz, wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: busses: ali1563: fix checkpatch.pl issues
Message-ID: <20140411163803.2b18114a@endymion.delvare>
In-Reply-To: <1397216684-6332-1-git-send-email-me@g0hl1n.net>
References: <1397216684-6332-1-git-send-email-me@g0hl1n.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 13:44:44 +0200, Richard Leitner wrote:
> Fixed most checkpatch.pl issues
> 
> Signed-off-by: Richard Leitner <me@g0hl1n.net>
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> ---
> v2: applied changes recommended by Jean Delvare
> ---
>  drivers/i2c/busses/i2c-ali1563.c | 82 ++++++++++++++++++++++------------------
>  1 file changed, 45 insertions(+), 37 deletions(-)
> (...)

Very nice, thank you.

Wolfram, please apply.

-- 
Jean Delvare
SUSE L3 Support

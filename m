Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab3LKH6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:58:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36683 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3LKH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:58:54 -0500
Date: Wed, 11 Dec 2013 07:58:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>,
        netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: Re: [B.A.T.M.A.N.] [PATCH -next 2/3] batman-adv: Use seq_overflow
Message-ID: <20131211075852.GS10323@ZenIV.linux.org.uk>
References: <cover.1386738050.git.joe@perches.com>
 <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
 <52A813C1.8070404@meshcoding.com>
 <52A814D7.1060805@meshcoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A814D7.1060805@meshcoding.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:31:35AM +0100, Antonio Quartulli wrote:
> Joe,
> 
> we have other places in the batman-adv code where we use seq_printf, but
> at the moment we don't check the return value and we always return 0 at
> the end of the function.
> 
> I think we could use seq_overflow here as well?

Not if you want correctly behaving code...

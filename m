Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaJ0NSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:18:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaJ0NSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:18:33 -0400
Date: Mon, 27 Oct 2014 14:18:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 09/11] tty: ipwireless: Fix probable mask then right
 shift defects
Message-ID: <20141027131831.GE22943@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <cover.1414387334.git.joe@perches.com>
 <5f61fec0dbc7d50715800c94b19db5914b1af610.1414387334.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f61fec0dbc7d50715800c94b19db5914b1af610.1414387334.git.joe@perches.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 10:25:05PM -0700, Joe Perches wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the masks.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: David Sterba <dsterba@suse.cz>

Thanks.

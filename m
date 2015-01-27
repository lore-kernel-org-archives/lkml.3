Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbbA0XM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:12:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38021 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbbA0XMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:12:25 -0500
Date: Wed, 28 Jan 2015 00:12:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: James Dingwall <james@dingwall.me.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
Message-ID: <20150127231212.GF3351@pd.tnic>
References: <20150122055242.GA11089@dingwall.me.uk>
 <20150122082003.GA3441@pd.tnic>
 <54C10DB6.2050708@oracle.com>
 <54C10ED0.1010302@oracle.com>
 <20150122153002.GA3554@pd.tnic>
 <20150127221231.GE3351@pd.tnic>
 <54C81755.4080502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C81755.4080502@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 05:55:17PM -0500, Boris Ostrovsky wrote:
> Will do. This needs to go to stable as well, right?

Right, add "# 3.18" as a comment after the CC:stable line as I haven't
done the backports for the older stable kernels yet. I'll submit it for
the older ones myself, along with the rest of the commits.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3LDC70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:59:26 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48866 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3LDC7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:59:23 -0500
Date: Tue, 03 Dec 2013 20:59:19 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] devtmpfs: Calling delete_path() only when necessary
To: Axel Lin <axel.lin@ingics.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1384589723.7840.1.camel@phoenix> (from axel.lin@ingics.com on
	Sat Nov 16 02:15:23 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1386125959.1974.309@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 02:15:23 AM, Axel Lin wrote:
> The deleted variable is always 1 in current code.
> Initialize deleted variable to be 0, so delete_path() will be called  
> only when
> necessary.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

I'm not seeing this in linux-next, or a reply on the web archive.  
Assuming nobody's objected to this, you might want to forward it to  
trivial@kernel.org.

That said, you could describe what it _does_ a little more?

Thanks,

Rob
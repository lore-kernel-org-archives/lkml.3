Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3DKTGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:06:38 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51558 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3DKTGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:06:35 -0400
Date: Thu, 11 Apr 2013 12:06:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, viro@ZenIV.linux.org.uk,
        netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 17/26] hostap: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130411190633.GB32045@kroah.com>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411132952.32763.3184.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411132952.32763.3184.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:29:52PM +0100, David Howells wrote:
> Don't use create_proc_read_entry() as that is deprecated, but rather use
> proc_create_data() and seq_file instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jouni Malinen <j@w1.fi>
> cc: John W. Linville <linville@tuxdriver.com>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: Johannes Berg <johannes@sipsolutions.net>
> cc: linux-wireless@vger.kernel.org
> cc: netdev@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

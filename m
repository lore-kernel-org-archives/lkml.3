Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab3CGFBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 00:01:43 -0500
Received: from tundra.namei.org ([65.99.196.166]:59618 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3CGFBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 00:01:42 -0500
Date: Thu, 7 Mar 2013 15:59:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@linux-foundation.org, keyrings@linux-nfs.org, pmatouse@redhat.com,
        security@kernel.org, linux-kernel@vger.kernel.org, mguzik@redhat.com,
        ben@decadent.org.uk
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
In-Reply-To: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.02.1303071558030.25164@tundra.namei.org>
References: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, David Howells wrote:

> Reported-by: Mateusz Guzik <mguzik@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: James Morris <james.l.morris@oracle.com>



-- 
James Morris
<jmorris@namei.org>

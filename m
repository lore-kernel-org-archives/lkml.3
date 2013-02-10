Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3BJXYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:24:13 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60145 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754536Ab3BJXYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:24:12 -0500
Message-ID: <1360538650.2028.2.camel@joe-AO722>
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Sun, 10 Feb 2013 15:24:10 -0800
In-Reply-To: <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
References: <cover.1360528614.git.dborkman@redhat.com>
	 <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-10 at 23:00 +0100, Daniel Borkmann wrote:
> add memcmp_nta ({n}o {t}iming {a}ttacks)

Why should this be in the kernel?



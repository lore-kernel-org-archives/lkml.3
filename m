Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaCNQdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:33:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbaCNQdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:33:23 -0400
Message-ID: <53232F51.3000404@suse.cz>
Date: Fri, 14 Mar 2014 17:33:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Emily Maier <emilymaier@mykolab.com>
CC: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: enable use of password-protected signing keys
References: <52FD4E8F.2030905@mykolab.com>
In-Reply-To: <52FD4E8F.2030905@mykolab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-14 00:00, Emily Maier wrote:
> Currently, the module signing script assumes that the private key is 
> not password-protected. This patch makes it somewhat more secure by 
> checking of a password file ("signing_key.pass") exists and passing it 
> to OpenSSL if so.

I doubt that this makes the key any more secure.

Michal


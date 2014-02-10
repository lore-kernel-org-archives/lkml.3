Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaBJNvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:51:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbaBJNvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:51:14 -0500
Message-ID: <52F8D94D.4040307@suse.cz>
Date: Mon, 10 Feb 2014 14:51:09 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Emily Maier <emilymaier@mykolab.com>, Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH RFC] kernel build: enable use of password-protected signing
 keys
References: <52F8034B.8080303@mykolab.com>
In-Reply-To: <52F8034B.8080303@mykolab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.2.2014 23:38, Emily Maier wrote:
> Currently, the module signing script assumes that the private key is 
> not password-protected. This patch makes it slightly more secure by 
> allowing it to be passed in on the command line as "make 
> modules_install MOD_PASSWORD=abc". It's vulnerable to snooping during 
> the build of course, but so is an unprotected signing key.

The key's permissions can be set to 0600, while the make commandline is
visible in ps.

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667Ab3IDBlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:41:07 -0400
Received: from tundra.namei.org ([65.99.196.166]:48571 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab3IDBlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:41:06 -0400
Date: Wed, 4 Sep 2013 11:42:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
In-Reply-To: <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041142080.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> +	status = efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> +


What's 'L' ?


-- 
James Morris
<jmorris@namei.org>

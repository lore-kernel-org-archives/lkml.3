Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab3IDAq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:46:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:34543 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934093Ab3IDAqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:46:25 -0400
Date: Wed, 4 Sep 2013 10:46:53 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 05/11] asus-wmi: Restrict debugfs interface when module
 loading is restricted
In-Reply-To: <1378252218-18798-6-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041046340.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-6-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> We have no way of validating what all of the Asus WMI methods do on a
> given machine, and there's a risk that some will allow hardware state to
> be manipulated in such a way that arbitrary code can be executed in the
> kernel, circumventing module loading restrictions. Prevent that if any of
> these features are enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>

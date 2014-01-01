Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaAAPLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 10:11:48 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:58503 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaAAPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 10:11:47 -0500
Message-ID: <52C43027.7010702@shealevy.com>
Date: Wed, 01 Jan 2014 10:11:35 -0500
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131228 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Build and Source Tree Requirements for Out-of-tree Modules
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am a package maintainer for the kernel for the NixOS distribution. We 
support users building out-of-tree modules and other packages that might 
depend on the kernel source or build trees, but make modules_install 
copies the entire source and build trees (we build with $(O) set) to 
$(INSTALL_PATH), and those are some big paths to keep around. Is there 
any documentation on which of those files should actually be needed by 
any out-of-tree tools? For example I'm guessing the intermediate object 
files in the build tree or the .c files in the source tree are not 
necessary, but it would be nice if there were a definitive list of what 
could be removed to save space.

Regards,
Shea Levy

P.S. I am not subscribed to the list, please CC me in responses.

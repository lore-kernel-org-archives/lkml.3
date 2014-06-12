Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaFLIJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:09:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbaFLIJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:09:14 -0400
Message-ID: <53996027.70504@suse.cz>
Date: Thu, 12 Jun 2014 10:09:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Avoid circular dependency with zImage.%
References: <53984D4F.6040808@linux.vnet.ibm.com> <1402501243-28213-1-git-send-email-mmarek@suse.cz> <53990B48.8010902@linux.vnet.ibm.com>
In-Reply-To: <53990B48.8010902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 12.6.2014 04:07, Mike Qiu napsal(a):
> This v2 patch is good,
> 
> Tested-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>

Thanks. In kbuild.git it goes.

Michal

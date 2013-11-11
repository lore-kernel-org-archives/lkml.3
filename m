Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3KKQl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:41:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57221 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3KKQlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:41:20 -0500
Message-ID: <1384187558.18684.109.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: d.kasatkin@samsung.com, zohar@us.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>
Date: Mon, 11 Nov 2013 11:32:38 -0500
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111116-0928-0000-0000-000003895F1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-04 at 16:22 +0000, David Howells wrote:
> 
> The control op could also be used for other things like pushing a key
> into a TPM.
> 
> What do you think?

Trusted keys already creates a symmetric key based on the TPM RNG. 
What type of key would I be interested in pushing to the TPM?   What
usecase scenario would this solve?

thanks,

Mimi


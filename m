Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaFJPJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:09:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41327 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaFJPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:09:01 -0400
Date: Tue, 10 Jun 2014 16:08:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: Josh Boyer <jwboyer@redhat.com>, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
Message-ID: <20140610150848.GB7551@srcf.ucam.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
 <20140610122008.GA31944@hansolo.jdub.homelinux.org>
 <5397010E.2080903@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5397010E.2080903@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 03:58:54PM +0300, Dmitry Kasatkin wrote:

> It is tricky issue. But yes and no... If I forced to trust MS key to run
> SHIM, it does not mean
> that I want to trust MS key to run kernel and load modules or use MS key
> to valid other keys on system keyring.

A kernel parameter that refuses to trust the contents of DB would be 
acceptable, but DBX needs to be used unconditionally.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

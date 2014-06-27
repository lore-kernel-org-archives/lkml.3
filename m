Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaF0Rov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:44:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39604 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaF0Rot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:44:49 -0400
Message-ID: <1403891079.9446.12.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 4/6] KEYS: validate certificate trust only with
 selected owner key
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Fri, 27 Jun 2014 13:44:39 -0400
In-Reply-To: <7771.1403877346@warthog.procyon.org.uk>
References: <1403620852-16476-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <7771.1403877346@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062717-0928-0000-0000-000003064712
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 14:55 +0100, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > This patch defines a new kernel parameter 'keys_ownerid' to identify
> > the owner's key which must be used for trust validation of certificates.
> 
> "ca_keys" or "only_ca" instead, maybe?

Neither of these names reflect the concept of the machine owner or a
local key.  The initial patches named it 'owner_keyid'.  If kernel
parameters don't need to be prefixed with the subsystem, we could revert
the name change or call it localca_keyid.

Mimi


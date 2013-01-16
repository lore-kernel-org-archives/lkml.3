Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3APWfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:35:52 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56690 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab3APWfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:35:51 -0500
Message-ID: <1358375723.4593.206.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module <linux-security-module@vger.kernel.org>
Date: Wed, 16 Jan 2013 17:35:23 -0500
In-Reply-To: <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011622-9360-0000-0000-00000F4C5EE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 16:34 -0500, Vivek Goyal wrote:
> If a binary is signed, verify its signature. If signature is not valid, do
> not allow execution. If binary is not signed, execution is allowed
> unconditionally.

Basically you're building the policy into the executable.  Anyone can
rebuild the executable and, without signing it, install/replace an
existing one.  How is this safe?  The signature verification policy
needs to be defined independently of the executable.

Mimi


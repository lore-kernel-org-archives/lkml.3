Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3CNUhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3CNUhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:37:06 -0400
Date: Thu, 14 Mar 2013 16:37:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH] integrity: Use a new type for asymmetric signature
Message-ID: <20130314203703.GF24238@redhat.com>
References: <20130314182815.GB24238@redhat.com>
 <CALLzPKZgSjtodeikffsRyZrq5eS92ziLm3NdjWmD878xL_kFVw@mail.gmail.com>
 <20130314203028.GE24238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314203028.GE24238@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 04:30:28PM -0400, Vivek Goyal wrote:

[..]
> I thought explicitly using signature format is more intutive. Exporting
> signature version is not. I personally associate versioning with minor
> changes like addition of some fields etc.

For instance, you might want to add some fields to  signature_v2_hdr down
the line. I think even after that change, it still remains "asymmetric
signature" just that structure size changes and there is additional
info. If there is versioning info assciated with signature type
ASYMMETRIC, we could simple bump it to 1.1 or whatever and keep the
version detail internal to ima/integrity subsystem.

Thanks
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3AQRwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:52:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3AQRwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:52:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
References: <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com> <cover.1358246017.git.dmitry.kasatkin@intel.com> <cover.1358246017.git.dmitry.kasatkin@intel.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric keys
Date: Thu, 17 Jan 2013 17:52:00 +0000
Message-ID: <27614.1358445120@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks reasonable, I think, so you can add:

	Acked-by: David Howells <dhowells@redhat.com>

David

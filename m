Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3LLPcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:32:22 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33539 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3LLPcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:32:19 -0500
Message-ID: <1386862039.1791.308.camel@misato.fc.hp.com>
Subject: Re: [PATCH] Driver core: Fix device_add_attrs() error code path
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Dec 2013 08:27:19 -0700
In-Reply-To: <1902491.UTh5DYb76O@vostro.rjw.lan>
References: <1902491.UTh5DYb76O@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 06:11 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> If the addition of dev_attr_online fails, device_add_attrs() should
> remove device attribute groups as well as type and class attribute
> groups before returning an error code.  Make that happen.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Nice catch!

Acked-by: Toshi Kani <toshi.kani@hp.com>

-Toshi


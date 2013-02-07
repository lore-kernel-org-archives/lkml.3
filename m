Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422723Ab3BGWbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:31:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3BGWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:31:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 02/11] mei: bus: Implement driver registration
Date: Thu, 7 Feb 2013 22:30:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-3-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072230.57943.arnd@arndb.de>
X-Provags-ID: V02:K0:C8VKl4py1TtlNcunEGUqjt0M7T3YLdqMBox9IqSC9Qi
 cQGD8BGAqvDBoM2vcziqLzKsfQgMapFtpPtxHqEuKvAdK42PYE
 KeG9CoCmJLkXALLgudLYl4ZO/dpqQ+uf/CzpRqmI3eCuyCe/1m
 YvGiTatU5WOYYZgus/NSqbmb3RlvFkmuAlHm8WRQJKRKB3w1ld
 7rr5XPHIkv777FzjLK36aKQFu0AfurCxE6CJeXHjf38EWnCm9p
 pluJh2WJWBZ3CNXnM5/l/dQoqiu9j6o7eqxMfTOZPyjAzqrLdc
 Ubs8KEwE00w0BfMQazNDRDmDVJcLMTG5pFk9hOknbky3wOH71q
 FXGBj6lHQlY+O2gOdHkk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:

> +int mei_add_driver(struct mei_bus_driver *driver)

By convention, I think this should be called mei_driver_register(),
matching what we do on most other subsystem. Similarly
for mei_driver_unregister().

	Arnd

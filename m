Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaF3Kjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:39:51 -0400
Received: from mx02.posteo.de ([89.146.194.165]:36424 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752486AbaF3Kjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:39:49 -0400
Message-ID: <53B13E4B.2080603@posteo.de>
Date: Mon, 30 Jun 2014 12:39:07 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [BUG] rc1 rc2 rc3 not bootable - black screen after kernel loading
References: <53A6E72A.9090000@posteo.de>	 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>	 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>	 <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba>	 <53ADB359.4010401@posteo.de> <53ADCB24.9030206@posteo.de>	 <53ADECDA.60600@posteo.de> <53B11749.3020902@posteo.de>	 <1404116299.8366.0.camel@rzhang1-toshiba> <1404116444.8366.1.camel@rzhang1-toshiba> <53B12723.4080902@posteo.de>
In-Reply-To: <53B12723.4080902@posteo.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

back to aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
commit. why is this not revertable exactly? how can I show a complete
list of commits this merge introduces?

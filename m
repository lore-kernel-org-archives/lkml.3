Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3KVSkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:40:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49861 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3KVSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:40:37 -0500
Message-ID: <528FA520.7080501@wwwdotorg.org>
Date: Fri, 22 Nov 2013 11:40:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com> <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:14 AM, Mika Westerberg wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> All platforms using this driver are now converted to the new
> descriptor-based GPIO interface.

Don't you want to remove the fields from the pdata structure too, since
it's pointless to set them anymore IIUC?

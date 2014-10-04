Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaJDM44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 08:56:56 -0400
Received: from mout.web.de ([212.227.15.4]:53558 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaJDM4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 08:56:55 -0400
Message-ID: <542FEE4A.4040401@users.sourceforge.net>
Date: Sat, 04 Oct 2014 14:55:38 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ewan Milne <emilne@redhat.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Hannes Reinecke <hare@suse.de>, Jean Delvare <jdelvare@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        Robert Milasan <rmilasan@suse.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Santosh Rastapur <santosh@chelsio.com>, Takashi Iwai <tiwai@suse.de>,
        Tom Gundersen <teg@jklm.no>, Werner Fink <werner@suse.de>
Subject: Re: [Cocci] [PATCH v2 2/7] module: add extra argument for parse_params()
 callback
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com> <1412372683-2003-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1412372683-2003-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:k9m0yyzE6xspPdti6cGyMxBnq6MaxJrimJ56tljv/FF0Y17MCZd
 r2KyWSWYL1t5xYc+y9NNEDmswaTZnRa3cM7ChhM6tqV5pXzciskBZphcoztxyI9oahmfMWt
 Grn+rWagivUsB/uONNGeqsQUNV2Cs+VosXx/CNPZac/IyxX++kUCPBBVe+z+TQIvMZ+oZx1
 jCBfWOl1RhV07vBMdZA+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds an extra argument onto parse_params() to be used
> as a way to make the unused callback a bit more useful and
> generic by allowing the caller to pass on a data structure
> of its choice.

How do you think about to work with more data type definitions for such callback
functions?

Regards,
Markus

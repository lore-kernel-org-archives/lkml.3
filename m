Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaJFVHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:07:09 -0400
Received: from mout.web.de ([212.227.17.12]:53507 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaJFVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:07:08 -0400
Message-ID: <5433045A.9000108@users.sourceforge.net>
Date: Mon, 06 Oct 2014 23:06:34 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, Tom Gundersen <teg@jklm.no>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Davidlohr Bueso <dbueso@suse.de>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Werner Fink <werner@suse.de>, linux-kernel@vger.kernel.org,
        Ewan Milne <emilne@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Santosh Rastapur <santosh@chelsio.com>, Petr Mladek <pmladek@suse.cz>,
        Robert Milasan <rmilasan@suse.com>, Hannes Reinecke <hare@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Coccinelle <cocci@systeme.lip6.fr>, Jean Delvare <jdelvare@suse.de>,
        Benjamin Poirier <bpoirier@suse.de>
Subject: Re: [Cocci] [PATCH v2 2/7] module: add extra argument for parse_params()
 callback
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com> <1412372683-2003-3-git-send-email-mcgrof@do-not-panic.com> <542FEE4A.4040401@users.sourceforge.net> <20141006203823.GB14081@wotan.suse.de>
In-Reply-To: <20141006203823.GB14081@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Ts9VlXeD9siU303TUPLLDtT6B7fekpz5xxqM4IQmhH8BhziY6oD
 rUb7EpmnxOU7+FQd8A/N0tYRBHUGBC1rpjd3htAca+0ZEQxPOeliQKQ7IVaCKOkpUVInuRh
 ArnSYoBYftDAlRZ5Be3COV8NNwMr5ZMM6mlC8UfTJLygEg4AV1QQPcCZE+MFbTHfxXUhvTt
 UOgQx9pKhB+zIcA+S2J2A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How do you think about to work with more data type definitions for such
>> callback functions?
> 
> Sorry I don't understand what you mean.

Can a specific "typedef" help in corresponding software maintenance?

Do you find descriptions from an other software application useful for such an
use case here?
http://www.fltk.org/doc-1.3/group__callback__functions.html

Regards,
Markus

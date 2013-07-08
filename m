Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3GHNK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3GHNK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:10:58 -0400
Date: Mon, 8 Jul 2013 15:10:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Greg Price <price@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Avoid missing macros FALSE, TRUE outside ui/gtk/
Message-ID: <20130708131052.GA2957@krava.brq.redhat.com>
References: <20130708121148.GC15534@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708121148.GC15534@biohazard-cafe.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 08:11:50AM -0400, Greg Price wrote:
> We use these macros in a few files in ui/gtk/ and they work fine
> because GTK includes GLib which defines them, but here in util/
> they break the build, at least on my machine.  So stick to 0 and 1.

and here's another one, pick at your will :))

http://marc.info/?l=linux-kernel&m=137320542616579&w=2

jirka

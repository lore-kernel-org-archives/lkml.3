Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3GHNnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:43:35 -0400
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:43381 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab3GHNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:43:34 -0400
X-AuditID: 1209190e-b7f988e0000009a7-bb-51dac2052618
Date: Mon, 8 Jul 2013 09:43:28 -0400
From: Greg Price <price@MIT.EDU>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Avoid missing macros FALSE, TRUE outside ui/gtk/
Message-ID: <20130708134328.GQ22203@biohazard-cafe.mit.edu>
References: <20130708121148.GC15534@biohazard-cafe.mit.edu>
 <20130708131052.GA2957@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708131052.GA2957@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42IR4hRV1mU9dCvQYP1DJYuD3dfZLI6e/ctk
	cXnXHDaLh6dsHVg8dm3byeTxft9VNo/Pm+QCmKO4bFJSczLLUov07RK4MiZsfMZc8IO54tuq
	N2wNjN3MXYycHBICJhKLlm9igrDFJC7cW8/WxcjFISSwj1Fizotz7BDOBkaJ9Ud3skI4nxgl
	Fsy8DNTCwcEioCLx5pU/SDebgILEj/nrwKaKANlPm/qZQUqYBcol3h9OBQkLC3hLXFq7hQ3E
	5hWwlpj0ZheYLSSQJdG8ZjorRFxQ4uTMJywgNrOAlsSNfy+ZIMZISyz/xwES5hSwlHgw9TZY
	uSjQAdf2t7NNYBSchaR7FpLuWQjdCxiZVzHKpuRW6eYmZuYUpybrFicn5uWlFuka6+Vmluil
	ppRuYgQHtSTfDsavB5UOMQpwMCrx8J44fzNQiDWxrLgy9xCjJAeTkijv2i23AoX4kvJTKjMS
	izPii0pzUosPMUpwMCuJ8IqzAuV4UxIrq1KL8mFS0hwsSuK8z56eDRQSSE8sSc1OTS1ILYLJ
	ynBwKEnw/j4A1ChYlJqeWpGWmVOCkGbi4AQZzgM0nPkgyPDigsTc4sx0iPwpRkUpcd4XIM0C
	IImM0jy4XljSecUoDvSKMK8mSDsPMGHBdb8CGswENLghDWxwSSJCSqqB0TX90+xd9dsCGLb+
	XVNS33q3b1WSMlPJHD4XvZkb/rSbfdk05/i28jM3PQIn+H1LW3y8QVrIXlvz0g/rI+mNT9jV
	tm67Oq2H0fvLPTm9gli35Af729iiWP0MvJkvx/5tmaH979O8JobErU77FwttW9LIeZ05zTQx
	S+uR1L3i33fORMslzvKfq8RSnJFoqMVcVJwIAG9KkisVAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:10:52PM +0200, Jiri Olsa wrote:
> On Mon, Jul 08, 2013 at 08:11:50AM -0400, Greg Price wrote:
> > We use these macros in a few files in ui/gtk/ and they work fine
> > because GTK includes GLib which defines them, but here in util/
> > they break the build, at least on my machine.  So stick to 0 and 1.
> 
> and here's another one, pick at your will :))
> 
> http://marc.info/?l=linux-kernel&m=137320542616579&w=2

Ah excellent, that's a better fix, thanks.

Greg

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3BBOT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:19:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526Ab3BBOT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:56 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yMpz74ztX9kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NfYGE617CmYA:10 a=VwQbUJbxAAAA:8 a=WoUo0jBCoJkYw90kX-YA:9 a=QEXdDO2ut3YA:10 a=IlIawqKe6hiOsFT_cPkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141842.189550803@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/11] [GIT PULL] tracing: Various tracing fixes and enhancements
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: d840f718d28715a9833c1a8f46c2493ff3fd219b


Hiraku Toyooka (3):
      tracing: Replace static old_tracer check of tracer name
      tracing: Make a snapshot feature available from userspace
      tracing: Add documentation of snapshot utility

Josh Triplett (1):
      tracing: Mark tracing_dentry_percpu() static

Jovi Zhang (1):
      tracing: Remove second iterator initializer

Namhyung Kim (1):
      tracing: Use sched_clock_cpu for trace_clock_global

Shan Wei (1):
      tracing: Use __this_cpu_inc/dec operation instead of __get_cpu_var

Steven Rostedt (1):
      tracing: Remove tracepoint sample code

Steven Rostedt (Red Hat) (3):
      tracing/fgraph: Adjust fgraph depth before calling trace return callb=
ack
      ring-buffer: Add stats field for amount read from trace ring buffer
      tracing: Init current_trace to nop_trace and remove NULL checks

----
 Documentation/trace/ftrace.txt                 |   83 +++++++++
 include/linux/ftrace_event.h                   |    3 +
 include/linux/ring_buffer.h                    |    1 +
 kernel/trace/Kconfig                           |   10 ++
 kernel/trace/ring_buffer.c                     |   18 ++
 kernel/trace/trace.c                           |  222 +++++++++++++++++---=
----
 kernel/trace/trace.h                           |    1 +
 kernel/trace/trace_clock.c                     |    2 +-
 kernel/trace/trace_functions_graph.c           |    8 +-
 samples/Kconfig                                |    6 -
 samples/Makefile                               |    2 +-
 samples/tracepoints/Makefile                   |    6 -
 samples/tracepoints/tp-samples-trace.h         |   11 --
 samples/tracepoints/tracepoint-probe-sample.c  |   57 ------
 samples/tracepoints/tracepoint-probe-sample2.c |   44 -----
 samples/tracepoints/tracepoint-sample.c        |   57 ------
 16 files changed, 288 insertions(+), 243 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCHAAoJEOdOSU1xswtM88kH/24gKCvP0JNMu5KTcj7eIjs/
wf3rQ19LpNI9Kn8PXJh2ofeejob81MvWPn+ieIarE7r1dlYXYmdZtngNqckVNEc9
A8QsZagsTA5EPskg01mSoUnj/wrTPHHN9eKXHceT6mWF+uK4cmy+wc1UezEGtpQt
/xbECurPRBLZOnSYzoWu+N3KYMDVp8uQFIe2Hh8iYLwK9kp1HBguxBwExnu/p5HA
TtvpvqrwO1cXz9Nld6WaWp8GqM4MPoi+h40VLuDBQvdGHFLQpjucfd1p+D3IBs+i
pMQbo9xhAknHdLCN6nTb3de8ltoU5rXO8Ao2Q85XeA1CZKtoQYk82drB0NfdNKc=
=Kmm2
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
